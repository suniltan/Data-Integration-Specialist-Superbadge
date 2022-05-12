@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here
  
  	@testSetup
    static void setup(){
        
        ServiceCredentials__c credential = new ServiceCredentials__c();
        credential.Name = 'BillingServiceCredential';
        credential.Username__c = 'userName';
        credential.Password__c = 'passWord';
        insert credential;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'Test Opportunity';
        opp.Type = 'New Project';
        opp.CloseDate = Date.today();
        opp.StageName = 'Prospecting';
        opp.Amount = 100000;
        insert opp;
        
        Project__c project = new Project__c();
        project.Name = 'Test project';
		project.ProjectRef__c = 'Test project ref';	
		project.Billable_Amount__c = 100000;
		project.Status__c = 'Running';        
		project.Opportunity__c = opp.Id;
        insert project; 
    }
    @isTest
    static void testBillingCalloutServiceSuccess() {
		List<Project__c>   projects = [SELECT Id FROM Project__c WHERE Name = 'Test project']   ;   
        for (Project__c project : projects) {
            project.Status__c = 'Billable';	
        }
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        update projects;
        Test.stopTest();
        
        projects = [SELECT Status__c FROM Project__c WHERE Name = 'Test project']   ; 
        System.assertEquals('Billed', projects[0].Status__c);
    }
    
    @isTest
    static void testBillingCalloutServiceFailure() {
		List<Project__c>   projects = [SELECT Id FROM Project__c WHERE Name = 'Test project']   ;   
        for (Project__c project : projects) {
            project.Status__c = 'Running';	
        }
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        update projects;
        Test.stopTest();
        
        projects = [SELECT Status__c FROM Project__c WHERE Name = 'Test project']   ; 
        System.assertEquals('Running', projects[0].Status__c);
    }
}
