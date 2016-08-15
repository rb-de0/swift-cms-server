import Vapor

class SecureUtil{

    class func setAuthenticityToken(application: Application, request: Request){

        // スタートさせる...
        request.session?["start"] = "hoge"

        let token = application.hash.make(request.session!.identifier!)
        request.session?["authenticity_token"] = token
    }

    class func verifyAuthenticityToken(application: Application, request: Request) -> Bool{
        guard let session = request.session, identifier = session.identifier else{
            return false
        }

        let token = application.hash.make(identifier)
        return session["authenticity_token"] == token
    }

    // mustacheでエスケープさせずに手動で一部エスケープ
    class func stringOfEscapedScript(html: String) -> String{
        return html.replacingOccurrences(of: "</script>", with: "&lt;/script&gt;").replacingOccurrences(of: "<script>", with: "&lt;script&gt;")
    }
}