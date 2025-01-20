@isTest
global with sharing class MockHttpResponseCheckSyncGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Object Name":"Lead","Organization Id":"00Df4000004klpHEAQ","UserId":"005f400000324XCAAY"}');
        res.setStatusCode(200);
        return res;
    }
}