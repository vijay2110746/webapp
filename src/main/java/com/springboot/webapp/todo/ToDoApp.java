package com.springboot.webapp.todo;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ToDoApp {
	
	private ToDoService todoservice;
	
	
	public ToDoApp(ToDoService todoservice) {
		super();
		this.todoservice = todoservice;
	}


	@RequestMapping("todo-see")
	public String todoApp(ModelMap model) {
		List<ToDo> todos = todoservice.getByUserName();
		model.addAttribute("todo", todos);
		
		return "todos";
	}

}
