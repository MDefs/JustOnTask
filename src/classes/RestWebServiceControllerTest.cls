/**
 * Created by George Bandatch on 8/6/2020.
 */

@IsTest
public with sharing class RestWebServiceControllerTest {

    private static final String UNINITIALIZED_ARGUMENT = Label.Uninitialized_Argument;

    @IsTest
    private static void processPostRequestTest() {
        RequestBody requestBody = new RequestBody();
        requestBody.address = new RequestBody.Address();
        requestBody.address.values = new Integer[]{
                74, 117, 115, 116, 79, 110
        };

        RestContext.response = new RestResponse();

        RestWebServiceController.processPostRequest(requestBody.address, null);

        System.assertEquals('{"result":8}', RestContext.response.responseBody.toString());
        System.assertEquals(200, RestContext.response.statusCode);
        System.assertEquals(1, [SELECT Id FROM WebServiceHistory__c].size());
    }

    @IsTest
    private static void processingExceptionTest() {
        RequestBody requestBody = new RequestBody();
        requestBody.address = new RequestBody.Address();

        RestContext.response = new RestResponse();

        try {
            RestWebServiceController.processPostRequest(requestBody.address, null);
        } catch (ProcessingException ex) {
            System.assertEquals(ex.getMessage(), UNINITIALIZED_ARGUMENT);
        }

        System.assertEquals('{"statusCode":400,"message":"' + UNINITIALIZED_ARGUMENT + '"}', RestContext.response.responseBody.toString());
        System.assertEquals(400, RestContext.response.statusCode);
        System.assertEquals(0, [SELECT Id FROM WebServiceHistory__c].size());
    }

}
