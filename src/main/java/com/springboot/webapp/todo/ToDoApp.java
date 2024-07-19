package com.springboot.webapp.todo;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

@Controller
@SessionAttributes("name")
public class ToDoApp {
	
	private ToDoService todoservice;
	
	
	public ToDoApp(ToDoService todoservice) {
		super();
		this.todoservice = todoservice;
	}


	@RequestMapping("todo-see")
	public String todoApp(ModelMap model) {
		List<ToDo> todos = todoservice.getByUserName();
//		model.put("name", name);
		model.addAttribute("todo", todos);
		
		return "todos";
	}
	
	@RequestMapping(value = "add-todo" , method=RequestMethod.GET)
	public String addTodo() {


		return "addtodo";
	}
	
	@RequestMapping(value = "add-todo" , method=RequestMethod.POST)
	public String showTodo(@RequestParam String description, ModelMap model) {

		todoservice.addToDo((String)model.get("name"), description);
		return "redirect:todo-see";
	}



}
