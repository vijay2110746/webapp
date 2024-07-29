			<%@ include file="common/header.jspf"  %>

			<%@ include file="common/navigation.jspf"  %>
	
		<div class="container">
		<h2>Welcome ${name}</h2>
			<h1>Your Todos</h1>
			<table class="table">
				<thead>
					<tr>
						<th>Description</th>
						<th>Target Date</th>
						<th>Is Done?</th>
					</tr>
				</thead>
				<tbody>		
					<c:forEach items="${todo}" var="todo">
						<tr>
							<td>${todo.description}</td>
							<td>${todo.targetDate}</td>
							<td>${todo.done}</td>
							<td><a href="deletetodo?id=${todo.id}" class="btn btn-success">Delete</a></td>
							<td><a href="updatetodo?id=${todo.id}" class="btn btn-warning">Update</a></td>
					
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<a href ="add-todo" class="btn btn-success">Add ToDo</a>
		</div>
		<%@ include file="common/footer.jspf" %>
