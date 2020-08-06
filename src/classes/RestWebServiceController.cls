/**
 * Created by George Bandatch on 8/6/2020.
 */

@RestResource(UrlMapping='/RestWebService')
global with sharing class RestWebServiceController {

    private static final String UNINITIALIZED_ARGUMENT = Label.Uninitialized_Argument;


    @HttpPost
    global static void processPostRequest(RequestBody.Address address, RequestBody.Meta meta) {
        try {
            ResponseBody responseBody = getResponse(address.values);
            RequestBody requestBody = new RequestBody();
            requestBody.address = address;
            requestBody.meta = meta;

            saveResult(requestBody, responseBody);
            sendResponse(200, responseBody);

        } catch (ProcessingException ex) {
            sendResponse(ex.statusCode, ex);
        } catch (DmlException ex) {
            sendResponse(406, ex);
        } catch (Exception ex) {
            sendResponse(500, ex);
        }

    }

    private static void saveResult(RequestBody requestBody, ResponseBody responseBody) {
        WebServiceHistory__c webServiceHistory = new WebServiceHistory__c();
        webServiceHistory.Result__c = responseBody.result;
        webServiceHistory.Request__c = JSON.serialize(requestBody);
        insert webServiceHistory;
    }

    private static ResponseBody getResponse(Integer[] values) {
        if (!valuesValid(values)) {
            throw new ProcessingException(400, UNINITIALIZED_ARGUMENT);
        }

        Integer valuesSum = getValuesSum(values);
        ResponseBody responseBody = new ResponseBody();
        responseBody.result = getDigitsSum(valuesSum);

        return responseBody;
    }

    private static Boolean valuesValid(Integer[] values) {
        return values != null && !values.isEmpty();
    }

    private static Integer getValuesSum(Integer[] values) {
        Integer sum = 0;

        for (Integer value : values) {
            sum += value;
        }

        return sum;
    }

    private static Integer getDigitsSum(Integer numeric) {
        String[] digits = String.valueOf(numeric).split('');
        Integer sum = 0;

        for (String digit : digits) {
            sum += Integer.valueOf(digit);
        }

        return sum;
    }

    private static void sendResponse(Integer statusCode, Object responseBody) {
        RestResponse res = RestContext.response;
        res.statusCode = statusCode;
        res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
    }

    global class ResponseBody {
        public Integer result;
    }

}
