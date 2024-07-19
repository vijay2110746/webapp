package com.springboot.webapp.loginController;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

@Controller
@SessionAttributes("name")
public class LoginController {
	
	@RequestMapping(value = "login",method = RequestMethod.GET)
	public String userLogin() {
		return "login";
	}
	
	@RequestMapping(value = "login",method = RequestMethod.POST)
	public String welcomePage(@RequestParam String username,@RequestParam String password, ModelMap map) {
		map.put("password", password);
		map.put("name", username);

		return "welcome";
	}


}
