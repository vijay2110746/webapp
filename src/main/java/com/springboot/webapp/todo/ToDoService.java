package com.springboot.webapp.todo;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

import org.springframework.stereotype.Service;

import jakarta.validation.Valid;

@Service
public class ToDoService {
	
	private static int listCount= 0;
	
	private static List<ToDo> todos = new ArrayList<ToDo>();
	
	static {
		LocalDate dueDate = LocalDate.now().plusYears(1);
		todos.add(new ToDo(++listCount,"learn something","AWS",dueDate,false));
	}
	
	public List<ToDo> getByUserName(){
		return todos;
	} 
	
	public void addToDo(String username, String description, LocalDate dueDate) {
		ToDo todo=new ToDo(++listCount,username , description,dueDate ,false);
		todos.add(todo);
		
	}

	public void DeleteToDo(int id) {
		
		Predicate<? super ToDo> predicate = todo->todo.getId() ==id;
		todos.removeIf(predicate);
		
	}

	public ToDo findbyId(int id) {
		Predicate<? super ToDo> predicate = todo->todo.getId() ==id; 
		ToDo todo = todos.stream().filter(predicate).findFirst().get();		
		return todo;
	}

	public void updateToDo(@Valid ToDo todo) {
		DeleteToDo(todo.getId());
		todos.add(todo);
		
	}
	

}
