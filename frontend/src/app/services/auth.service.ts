import { tap } from 'rxjs/operators';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private API_URL = 'http://localhost:3000';

  private isLoggedIn = false;

  constructor(private router: Router, private http: HttpClient) {}

  signup(payload: { username: string; password: string }) {
    return this.http.post(`${this.API_URL}/signup`, payload);
  }

  login(payload: { username: string; password: string }) {
    return this.http.post(`${this.API_URL}/login`, payload).pipe(
      tap(() => {
        this.isLoggedIn = true;
        this.router.navigate([`${this.API_URL}/dashboard`]);
      })
    );
  }

  logout() {
    this.isLoggedIn = false;
    this.router.navigate([`${this.API_URL}/login`]);
  }

  userIsAuthenticated(): boolean {
    return this.isLoggedIn;
  }
}
