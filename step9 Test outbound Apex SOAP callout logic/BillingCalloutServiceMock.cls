global class BillingCalloutServiceMock implements WebServiceMock {
   //Implement http mock callout here
   global Void doInvoke(Object stub, 
                        Object soapRequest, 
                        Map<String,Object> responseMap, 
                        String endpoint, 
                        String soapAction, 
                        String requestName, 
                        String responseNamespace, 
                        String responseName, 
                        String responseType) {
                            BillingServiceProxy.billProjectResponse_element responseElement = new BillingServiceProxy.billProjectResponse_element();
                            responseElement.status = 'OK';
                            responseMap.put('response_x', responseElement);
                            
                        }
}
