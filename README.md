#Rails Lite
A web server MVC framework inspired by the functionality of Ruby on Rails which enables the basic communication among MVC. Base on the logic of Rails, I have implemented methods that bridge the functionality of MVC as well as some basic functions such as session and flash to obtain a better connection among different requests.

##Controller
The controller takes a request, a response and router params (if any). The main function of Controller is to either render content or redirect the page. In its role of communicating with server and clients, it takes a request and reads the information, calls the corresponding actions, and generates a response back to the clients. I also implemented the CSRF protection to ensure safe input.

##Router
The Router stores Routes and generates methods based on given HTTP methods. Routes are created depending on the http method and action. After the router finds a matched route, it then calls the corresponding controller and action.

##Session
Session is used to communicate among different requests, such as checking the current user status by session token. It stores the cookies from the request and also sends the cookies as part of the response.

##Params
The params can be obtained by three ways: 1) query string 2) post body 3) route params. The main function in the params class is to parse the data and elegantly converts all nested values in the array to a properly formatted, deeply nested hash

###Flash
The main function of flash is to provide a short-term memorized information only for the next request(or current request like flash.now). Flash takes in data from cookies and uses it in current request. It clears out all of the previous data and only sends new data for the next request.

###URL helper
URL helper provides methods that can generate corresponding URL, so users don't need to tediously type in the whole URL. It is called in Controller#initialize, and generates the custom URL helper methods depending on the Controller class.
