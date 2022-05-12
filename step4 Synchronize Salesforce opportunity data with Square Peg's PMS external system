public class ProjectCalloutService {
    
    @invocableMethod
	public static void postOpportunityToPMS(List<Id> opportunityIds){
        if(opportunityIds.size() > 0){
            System.enqueueJob(new QueueablePMSCall(opportunityIds));
        }
    }
    
    static void doRESTfulCall(Opportunity opp, String projectServiceToken){
        HttpRequest request = new HttpRequest();

        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('token', projectServiceToken);
        request.setEndpoint('callout:ProjectService');
        request.setBody(JSON.serialize(new CalloutInformationWrapper(opp)));
        
        HttpResponse response = new Http().send(request);
        
        if(response.getStatusCode() == 201 && response.getStatus() == 'OK'){
            opp.StageName = 'Submitted Project';
        }
        else if(response.getStatusCode() == 500){
            opp.StageName = 'Resubmit Project';
        }
        
        update opp;       
    }
    
    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts{
        List<Id> opportunitiyIdsToProcess;
        
        public QueueablePMSCall(List<Id> opportunitiyIds){
            opportunitiyIdsToProcess = opportunitiyIds;
        }
        
        //Class ProjectCalloutService.QueueablePMSCall must implement the method
        public void execute(System.QueueableContext context){
            List<Opportunity> opportunitiesData = [SELECT ID, Name, Account.Name, CloseDate, Amount
                                                       FROM Opportunity
                                                       WHERE Id In :opportunitiyIdsToProcess];
            if(opportunitiesData.size() > 0){           
                doRESTfulCall(opportunitiesData[0], ServiceTokens__c.getInstance('ProjectServiceToken').Token__c);
            }
        }
    }
    
    public class CalloutInformationWrapper{
        string opportunityId;
        string opportunityName;
  		string accountName;
  		string closeDate;
  		Decimal amount;
        
        public CalloutInformationWrapper(Opportunity opp){
            this.opportunityId = opp.Id;
            this.opportunityName = opp.Name;
            this.accountName = opp.Account.Name;
            this.closeDate = String.valueOf(opp.CloseDate);
            this.amount = opp.Amount;
        }
	}
}
