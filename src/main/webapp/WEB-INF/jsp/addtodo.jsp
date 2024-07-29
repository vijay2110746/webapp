		<%@ include file="common/header.jspf"  %>

		<%@ include file="common/navigation.jspf"  %>
		<div class="container">
		<h2>Welcome ${name}</h2>
			<h1>Add Todos</h1>
			<form:form method="post" modelAttribute="todo">
				<fieldset >
				<form:label path="description">Description</form:label>
				<form:input type="text" name = "description" required="required" path="description"></form:input>
				<form:errors name = "description"  path="description"/>
				</fieldset>
				<fieldset>
				<form:label path="targetDate">Target Date</form:label>
				<form:input id="targetDate" type="text" required="required" path="targetDate"></form:input>

				<form:errors   path="targetDate"/>
				</fieldset>
				<form:input type="hidden"   path="id"></form:input>
				<form:input type="hidden"   path="done"></form:input>
				<input type="submit" class="btn btn-success" >
			</form:form>
		</div>
		<%@ include file="common/footer.jspf" %>
		<script type="text/javascript">
       $('#targetDate').datepicker({
            format: 'yyyy-mm-dd'
          }); 
		</script>
