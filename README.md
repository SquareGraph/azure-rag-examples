
Hey, I need you to help me create a bicep IaC files for setting up resources and relevant policies for the following infrastracture:

I'm creating RAG application, that could serve multiple clients at the same time. The architecture itself, will have two different queues - high priority (event grid) and low priority (service bus).

Main interface will be Azure API Managment.
Firstly, this APIM, will have semantic caching request implemented. So any request coming into it will be validated if the similar/same request are not cached. This will have to be done probably on policy level, to fetch things from the redis cache (I'm not sure if redis cache is a part of standard APIM setup, but if is not, than we will have to create this resource properly). The APIM, if cached request is found, should return it in it's response.

On the other, hand, if the request is not cached:
One endpoint (let's name it response endpoint), will be adding events to the high priority queue, and another (ingest) will be adding events to the low priority queue (aws service bus).

Both endpoints, will have schema defined using OpenAPI yaml files. Response endpoint schema will take as an input query:str, and ingest endpoint will take: b64_file: str, filename: str

Each of the respective queues will be triggering respectively different Azure Function. To allow for propper function execution, we will need additional resources like Cognitive Search, File Blob, Cosmos DB. Also, we will need two Azure OpenAI Services, both with the same LLM (smallest, cheapest model currently available). The difference between those services will be that one, will be Provisioned Throughput (smallest possible PTU), and the second one will be Pay as You Go.
In definition of those resources, PTU will have a value for priority of 1, PAYG will have priority of 2. This will be later on used for load balancing based on the event from the given queue. Basically, the idea here is to low priority events only access PTU resource, while Response High Priority events will have access to both, PTU and PAYG
Endpoints definition should also have implemented isThrottling: bool (that will be used to identify if the endpoint is returng 429), and RetryAfter (which will return numbe rof seconds after which to try again) attributes.

Each of the created AzureOpenAI endpoints, have to be added to apim-policy.xml as seperate backends.
Remember to add logic to the policy, before calling any of the endpoint, to check if  what isTrottiling returns (something like below example:

<when condition="@(context.Response != null && (context.Response.StatusCode == 429 || context.Response.StatusCode.ToString().StartsWith("5")) )">
    <cache-lookup-value key="listBackends" variable-name="listBackends" />
    <set-variable name="listBackends" value="@{
        JArray backends = (JArray)context.Variables["listBackends"];
        int currentBackendIndex = context.Variables.GetValueOrDefault<int>("backendIndex");
        int retryAfter = Convert.ToInt32(context.Response.Headers.GetValueOrDefault("Retry-After", "10"));

        JObject backend = (JObject)backends[currentBackendIndex];
        backend["isThrottling"] = true;
        backend["retryAfter"] = DateTime.Now.AddSeconds(retryAfter);

        return backends;      
    }" />)


We will also have to ensure that only authenticated requests will be able to reach to those endpoints through propper implementation of authentication-managed-identity, so we will have to turn on managed identity in  APIM and allow the identity in Azure Open AI.

Also on the azure function that is triggered by low priority events from Azure Service Bus, we have to implement Dead Letter Queue (also using Service Bus), for all events that failed. And this Dead Letter Queue should also trigger same azure function, until it converges.

Before proceeding to create respective bicep and xml files for above task, analyze everything in details, think and plan ahead.