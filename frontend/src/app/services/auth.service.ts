import { tap } from 'rxjs/operators';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private isLoggedIn = false;

  constructor(private router: Router, private http: HttpClient) {}

  signup(payload: { username: string; password: string }) {
    return this.http.post('/api/signup', payload);
  }

  login(payload: { username: string; password: string }) {
    return this.http.post('/api/login', payload).pipe(
      tap(() => {
        this.isLoggedIn = true;
        this.router.navigate(['/dashboard']);
      })
    );
  }

  logout() {
    this.isLoggedIn = false;
    this.router.navigate(['/login']);
  }

  userIsAuthenticated(): boolean {
    return this.isLoggedIn;
  }
}
