@isTest
private class ProjectRESTServiceTest {
    @testSetup
    static void setup(){        
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
    }  
    
    @isTest
    static void testProjectRestServiceSuccess(){
        
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity'];
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI='/services/apexrest/project';
        RestContext.request = request;
        Test.startTest();
        String response = ProjectRESTService.postProjectData(
							'Test Ref', 
                            'Test Project', 
                            opp.id, 
                            Date.today(), 
                            Date.today().addDays(1), 
                            100000, 
                            'Running'
        
        );
        Test.stopTest();
        opp = [SELECT DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('In progress', opp.DeliveryInstallationStatus__c);
        System.assertEquals('OK', response);
    }
    @isTest
    static void testProjectRestServiceFailure(){

        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI='/services/apexrest/project';
        RestContext.request = request;
        Test.startTest();
        String response = ProjectRESTService.postProjectData(
							'Test Ref', 
                            'Test Project', 
                            'Test OPP Id', 
                            Date.today(), 
                            Date.today().addDays(1), 
                            100000, 
                            'Running'
        
        );
        Test.stopTest();
        System.assertEquals('Invalid id: Test OPP Id', response);
    }
}
