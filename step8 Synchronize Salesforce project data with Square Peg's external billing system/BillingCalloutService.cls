public class BillingCalloutService {
    static final ServiceCredentials__c credential = ServiceCredentials__c.getInstance('BillingServiceCredential');
    //static ServiceCredentials__c credential = [SELECT Username__c, Password__c 
                                      // FROM ServiceCredentials__c 
                                      // WHERE Name = 'BillingServiceCredential'];
                                      // 
    public static void callBillingService(List<Project__c> newProjects, Map<Id, Project__c> oldProjectsMap){
        List<Project__c> projectsToFutureCallout = new List<Project__c>();
        
        for(Project__c project : newProjects){
            
            Project__c oldProject = oldProjectsMap.get(project.Id);
            //to trigger an outbound SOAP call anytime the project Status in their Salesforce org is set to Billable.
            if(project.Status__c == 'Billable' && project.Status__c != oldProject.Status__c){
                projectsToFutureCallout.add(project);
            }
        }
        
        if(projectsToFutureCallout.size() > 0){
            futureCallout(JSON.serialize(projectsToFutureCallout)); 
        }      
    }
    
    @future(callout = true)
    static void futureCallout(String serializedProjects){
        List<Project__c> projects = (List<Project__c>)JSON.deserialize(serializedProjects, List<Project__c>.class);
        List<Project__c> projectsToUpdate = new List<Project__c>();
        
        for(Project__c project : projects){
            BillingServiceProxy.InvoicesPortSoap11 invoicePort = new BillingServiceProxy.InvoicesPortSoap11();
            BillingServiceProxy.project extProject = new BillingServiceProxy.project();
            extProject.projectid = project.ProjectRef__c;
            extProject.billAmount = project.Billable_Amount__c;
            extProject.username = credential.Username__c;
            extProject.password = credential.Password__c;
            String response = invoicePort.billProject(extProject);
            
            if(response == 'OK'){
                //If the outbound call is successful, the project record’s status is updated to Billed
                project.Status__c = 'Billed';
                projectsToUpdate.add(project);
            }
        }
        
        if(projectsToUpdate.size() > 0){
            update projectsToUpdate;
        }
    }
}
