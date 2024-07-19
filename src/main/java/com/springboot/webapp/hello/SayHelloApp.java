package com.springboot.webapp.hello;

import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SayHelloApp {
	
	@RequestMapping("say-hello")
	@ResponseBody
	public String sayHello() {
		return "I am Vijay Veerasekaran";
	}
	
	@RequestMapping("say-hello-jsp")
	public String sayHelloJsp() {
		return "sayHello";
	}

}
