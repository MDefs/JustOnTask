/**
 * Created by HeorhiiBandach on 8/6/2020.
 */

public with sharing class ProcessingException extends Exception {

    public String message;
    public Integer statusCode;

    public ProcessingException(Integer statusCode, String message) {
        this.statusCode = statusCode;
        this.message = message;
    }

}
