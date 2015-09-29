#Rails Lite
A web server MVC framework inspired by the functionality of Ruby on Rails, enalbe the basic communication among MVC. Base on the logic of Rails, I implement methods that bridge the functionality of MVC as well as some basic functions such as session and flash to obtain better connection among different requests.

##Controller
The controller takes a request, a response and (if any) router params. The main function of Controller is to either render content or redirect the page. As a role of communicating with server and clients, it takes request and read the information and call the corresponding actions then generate response back to clients.

##Router
The Router stores Routes and generates methods based on given HTTP methods. Routes are created depends on the http method and action. After the router find matched route, it then call the corresponding controller and action.

##Session
Session is used to communicate among different requests such as checking current user status by session token. It stores the cookies from request and also sends cookies to response.

##Params
The params can be obtained by three ways: 1) query string 2) post body 3) route params. The main function in params class is to parse the data and elegantly converts all nested values in the array to a properly formatted, deeply nested hash

###Flash
The main function of flash is to provide a short-term memorized information only for next request(or current request like flash.now). Flash takes in data from cookies and use it in current request. Clear out all the previous data and only send new data for the next request.

###URL helper
URL helper provide methods that can generate corresponding URL, so users don't need to tediously type in the whole URL. Will be called in Controller#initialize and generate the custom URL helper methods depend on the Controller class.
