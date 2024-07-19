package com.springboot.webapp.todo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class ToDoService {
	
	private static List<ToDo> todos = new ArrayList<ToDo>();
	
	static {
		todos.add(new ToDo(1,"learn something","AWS",false));
	}
	
	public List<ToDo> getByUserName(){
		return todos;
	} 
	

}
