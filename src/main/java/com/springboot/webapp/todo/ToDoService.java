package com.springboot.webapp.todo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class ToDoService {
	
	private static int listCount= 0;
	
	private static List<ToDo> todos = new ArrayList<ToDo>();
	
	static {
		todos.add(new ToDo(++listCount,"learn something","AWS",false));
	}
	
	public List<ToDo> getByUserName(){
		return todos;
	} 
	
	public void addToDo(String username, String description) {
		ToDo todo=new ToDo(++listCount,username , description, false);
		todos.add(todo);
		
	}

}
