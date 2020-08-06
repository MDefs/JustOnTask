/**
 * Created by HeorhiiBandach on 8/6/2020.
 */

global with sharing class RequestBody {

    public Address address;
    public Meta meta;


    global class Address {
        public String[] colorKeys;
        public Integer[] values;
    }

    global class Meta {
        public Integer digits;
        public String processingPattern;
    }

}
