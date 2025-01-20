@isTest
global with sharing class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Object Name":"Lead","Organization Id":"00D7F000007DRsIUAW","UserId":"0057F000003JfVgQAK"}');
        res.setStatusCode(200);
        return res;
    }
}