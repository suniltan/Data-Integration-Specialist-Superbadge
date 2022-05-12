global class BillingCalloutServiceMockFailure {
    //Implement http mock callout failure here 
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
                             responseElement.status = 'UNAUTHORIZED';
                             responseMap.put('response_x', responseElement);
                             
                         }
}
