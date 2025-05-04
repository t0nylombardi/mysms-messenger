import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class MessagesService {
  private API_URL = environment.apiUrl;

  constructor(private http: HttpClient) {}

  getMessages(): Observable<HttpResponse<any>> {
    const token = localStorage.getItem('token');
    if (!token) {
      console.warn('[MessagesService] No token found in localStorage.');
    }

    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` })
    });

    return this.http.get(`${this.API_URL}/api/v1/messages`, {
      headers,
      observe: 'response',
      responseType: 'json'
    }).pipe(
      tap((response) => {
        const messages = response.body?.status?.data;
        if (messages) {
          console.log('Messages:', messages);
        } else {
          console.warn('[MessagesService] No messages in response.');
        }
      })
    );
  }

  sendMessage(message: any): Observable<HttpResponse<any>> {
    const token = localStorage.getItem('token');
    if (!token) {
      console.warn('[MessagesService] No token found in localStorage.');
    }

    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` })
    });

    return this.http.post(`${this.API_URL}/api/v1/messages`, message, {
      headers,
      observe: 'response',
      responseType: 'json'
    }).pipe(
      tap((response) => {
        const message = response.body?.status?.data;
        if (message) {
          console.log('Message sent:', message);
        } else {
          console.warn('[MessagesService] No message in response.');
        }
      })
    );
  }
}
