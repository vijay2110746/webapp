package com.springboot.webapp.todo;

import jakarta.validation.constraints.Size;

public class ToDo {

	private int id;
	private String name;
	@Size(min=10,message="enter a description greater than 10chars")
	private String description;
	private boolean done;
	
	
	public ToDo(int id, String name, String description, boolean done) {
		super();
		this.id = id;
		this.name = name;
		this.description = description;
		this.done = done;
	}


	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public String getDescription() {
		return description;
	}


	public void setDescription(String description) {
		this.description = description;
	}


	public boolean isDone() {
		return done;
	}


	public void setDone(boolean done) {
		this.done = done;
	}


	@Override
	public String toString() {
		return "ToDoService [id=" + id + ", name=" + name + ", description=" + description + ", done=" + done + "]";
	}
	
	

}
