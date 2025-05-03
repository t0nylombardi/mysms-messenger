import { tap } from 'rxjs/operators';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';

export type LoginPayload = {
  user: {
    email: string;
    password: string;
  };
};

export type SignupPayload = {
  user: {
    email: string;
    password: string;
    password_confirmation: string;
  };
};

export type MessagePayload = {
  message: {
    from: string;
    body: string;
    createdAt: string;
  };
};

@Injectable({ providedIn: 'root' })
export class AuthService {
  private API_URL = 'http://localhost:3000';

  private isLoggedIn = false;

  constructor(private router: Router, private http: HttpClient) {}

  login(payload: LoginPayload) {
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });

    return this.http.post(`${this.API_URL}/login`, payload, {
      headers,
      observe: 'response',
      responseType: 'json'
    }).pipe(
      tap((response: HttpResponse<any>) => {
        const token = this.extractToken(response);
        const userId = response.body?.status?.data?.id;

        if (!userId) {
          console.warn('[AuthService] Login failed: Missing user ID in response.');
          return;
        }

        if (!token) {
          console.warn('[AuthService] Login warning: No JWT token found in Authorization header.');
        }

        this.persistSession(userId, token);
        this.isLoggedIn = true;
        this.router.navigate(['/messages']);
      })
    );
  }

  signup(payload: SignupPayload) {
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    });

    return this.http.post(`${this.API_URL}/signup`, payload, {
      headers,
      observe: 'response',
      responseType: 'json'
    }).pipe(
      tap((response: HttpResponse<any>) => {
        const token = this.extractToken(response);
        const userId = response.body?.status?.data?.id;

        if (!userId) {
          console.warn('[AuthService] Login failed: Missing user ID in response.');
          return;
        }

        if (!token) {
          console.warn('[AuthService] Login warning: No JWT token found in Authorization header.');
        }

        this.persistSession(userId, token);
        this.isLoggedIn = true;
        this.router.navigate(['/messages']);
      })
    );
  }

  logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('userId');
    this.isLoggedIn = false;
    this.router.navigate([`${this.API_URL}/login`]);
  }

  userIsAuthenticated(): boolean {
    return this.isLoggedIn;
  }

  private extractToken(response: HttpResponse<any>): string | null {
    const authHeader = response.headers.get('authorization');
    return authHeader?.split(' ')?.[1] || null;
  }

  private persistSession(userId: string, token: string | null): void {
    localStorage.setItem('userId', userId);
    if (token) {
      localStorage.setItem('token', token);
    }
  }
}
