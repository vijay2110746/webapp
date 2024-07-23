package com.springboot.webapp.todo;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import jakarta.validation.Valid;

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
		List<ToDo> todo = todoservice.getByUserName();
//		model.put("name", name);
		model.addAttribute("todo", todo);
		
		return "todos";
	}
	
	@RequestMapping(value = "add-todo" , method=RequestMethod.GET)
	public String addTodo(ModelMap model) {
		String username = (String)model.get("name");
		LocalDate dueDate = LocalDate.now().plusYears(1);
		ToDo todo = new ToDo(0,username,"",dueDate,false);
		model.put("todo", todo);

		return "addtodo";
	}
	
	@RequestMapping(value = "add-todo" , method=RequestMethod.POST)
	public String showTodo( ModelMap model, @Valid @ModelAttribute("todo") ToDo todo, BindingResult result) {
		if (result.hasErrors()) {
			return "addtodo";
		}

		todoservice.addToDo((String)model.get("name"), todo.getDescription(),todo.getTargetDate());
		return "redirect:todo-see";
	} 
	
	@RequestMapping(value = "deletetodo")
	public String deleteTodo(@RequestParam int id) {
		todoservice.DeleteToDo(id);

		return "redirect:todo-see";
	}

	@RequestMapping(value = "updatetodo",method=RequestMethod.GET)
	public String updateTodo(@RequestParam int id,ModelMap model) {
		ToDo todo= todoservice.findbyId(id);
		model.addAttribute("todo",todo);
		return "addtodo";
	}
	
	@RequestMapping(value = "updatetodo" , method=RequestMethod.POST)
	public String showUpdateTodo( ModelMap model, @Valid @ModelAttribute("todo") ToDo todo, BindingResult result) {
		if (result.hasErrors()) {
			return "addtodo";
		}
		
		String username = (String)model.get("name");
		todo.setName(username);
		todoservice.updateToDo(todo);
		return "redirect:todo-see";
	}

}
