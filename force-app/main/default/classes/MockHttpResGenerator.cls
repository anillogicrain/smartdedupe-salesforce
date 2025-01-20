@isTest
global with sharing class MockHttpResGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"organisationId":"test","userId":"null","objectName":"Lead","dedupeFields":"LastName::Last Name","recordIds":"00Qf400000GBC0xEAH"}');
        res.setStatusCode(200);
        return res;
    }
}