package com.springboot.webapp.todo.security;

import java.util.function.Function;
import static org.springframework.security.config.Customizer.withDefaults;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;


@Configuration
public class SpringSecurityConfiguration {

	@Bean
	public InMemoryUserDetailsManager createUserDetails() {

		UserDetails userDetails = createNewUser("Vijay", "dummy");
		UserDetails userDetails1 = createNewUser("Vijay1", "dummy1");

		 
		return new InMemoryUserDetailsManager(userDetails,userDetails1);
		
	}

	private UserDetails createNewUser(String username, String password) {
		Function<String, String> passwordEncoder = input -> passwordEncoder().encode(input);

		UserDetails userDetails = User.builder().passwordEncoder(passwordEncoder)
				.username(username).
				password(password)
				.roles("USER","ADMIN").build();
		return userDetails;
	}
	
	
	@Bean 
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		
		http.authorizeHttpRequests(
		auth -> auth.anyRequest().authenticated());
		http.formLogin(withDefaults());
	    http.csrf(csrf -> csrf.disable());
	    http.headers(header -> header.frameOptions(frameOptions -> frameOptions.disable()));
		return http.build();
		}
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
}
