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
        const body: any = response.body;
        const userId = body?.status?.data?.id;

        if (userId) {
          sessionStorage.setItem('userId', userId);
          this.isLoggedIn = true;
          this.router.navigate(['/dashboard']);
        } else {
          console.warn('No user ID found in response');
        }
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
        const authHeader = response.headers.get('Authorization');
        const token = authHeader?.split(' ')?.[1];

        if (token) {
          sessionStorage.setItem('session', token);
          this.isLoggedIn = true;
          this.router.navigate(['/dashboard']);
        } else {
          console.warn('No JWT found in headers');
        }
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
