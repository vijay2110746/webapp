package com.springboot.webapp.todo;

import java.time.LocalDate;
import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
public class ToDoAppJpa {
	
	private ToDoService todoservice;
	private ToDoRepository todoRepository;
	

	
	public ToDoAppJpa(ToDoService todoservice,ToDoRepository todoRepository) {
		super();
		this.todoservice = todoservice;
		this.todoRepository = todoRepository;
	}


	@RequestMapping("todo-see")
	public String todoApp(ModelMap model) {
		String name = getLoggedInUsername(model);
		List<ToDo> todo = todoRepository.findByName(name);
//		model.put("name", name);
		model.addAttribute("todo", todo);
		
		return "todos";
	}
	
	@RequestMapping(value = "add-todo" , method=RequestMethod.GET)
	public String addTodo(ModelMap model) {
		String username = getLoggedInUsername(model);
		LocalDate dueDate = LocalDate.now();
		ToDo todo = new ToDo(0,username,"",dueDate,false);
		model.put("todo", todo);

		return "addtodo";
	}


	private String getLoggedInUsername(ModelMap model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		return authentication.getName();
	}
	
	@RequestMapping(value = "add-todo" , method=RequestMethod.POST)
	public String showTodo( ModelMap model, @Valid @ModelAttribute("todo") ToDo todo, BindingResult result) {
		if (result.hasErrors()) {
			return "addtodo";
		}
		
		todo.setName(getLoggedInUsername(model));
		todoRepository.save(todo);

//		todoservice.addToDo(getLoggedInUsername(model), todo.getDescription(),todo.getTargetDate());
		return "redirect:todo-see";
	} 
	
	@RequestMapping(value = "deletetodo")
	public String deleteTodo(@RequestParam int id) {
//		todoservice.DeleteToDo(id);
		todoRepository.deleteById(id);

		return "redirect:todo-see";
	}

	@RequestMapping(value = "updatetodo",method=RequestMethod.GET)
	public String updateTodo(@RequestParam int id,ModelMap model) {
		ToDo todo= todoRepository.findById(id).get();
		model.addAttribute("todo",todo);
		return "addtodo";
	}
	
	@RequestMapping(value = "updatetodo" , method=RequestMethod.POST)
	public String showUpdateTodo( ModelMap model, @Valid @ModelAttribute("todo") ToDo todo, BindingResult result) {
		if (result.hasErrors()) {
			return "addtodo";
		}
		
		String username = getLoggedInUsername(model);
		todo.setName(username);
		todoservice.updateToDo(todo);
		todoRepository.save(todo);
		return "redirect:todo-see";
	}

}
