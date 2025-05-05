import { Component, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpResponse } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { MessagesService } from '../../services/messages.service';
import { LogoutButtonComponent } from '../../shared/logout-button/logout-button.component';
import { PhoneFormatPipe } from '../../pipes/phone-format.pipe';
import { interval, Subscription } from 'rxjs';

@Component({
  standalone: true,
  selector: 'app-messages',
  imports: [
    CommonModule,
    FormsModule,
    RouterModule,
    LogoutButtonComponent,
    PhoneFormatPipe
  ],
  templateUrl: './messages.component.html',
  styleUrls: ['./messages.component.scss']
})
export class MessagesComponent implements OnDestroy {
  messages: any[] = [];
  msgCount: number = 0;

  SMSMaxLength = 250;

  get charCount(): number {
    return this.message.body?.length || 0;
  }

  private pollingSub?: Subscription;

  message = {
    to: '18777804236',
    body: ''
  };

  constructor(private messagesService: MessagesService) {}

  sendMessage(): void {
    const payload = { ...this.message };

    this.message.body = '';

    this.messagesService.sendMessage(payload).subscribe({
      next: (response: HttpResponse<any>) => {
        this.fetchMessages();
        const message = response.body?.message;
        if (message) {
          console.log('Message sent:', message);
        } else {
          console.warn('[MessagesComponent] No message in response.');
        }
      },
      error: (err: any) => console.error('Error sending message:', err)
    });
  }

  ngOnInit(): void {
    this.pollingSub = interval(3310).subscribe(() => this.fetchMessages());

    this.fetchMessages();
  }

  fetchMessages(): void {
    this.messagesService.getMessages().subscribe({
      next: (response: HttpResponse<any>) => {
        const messages = response.body?.messages;
        if (messages) {
          this.messages = messages;
          this.msgCount = messages.length;
          console.log('Messages:', this.messages);
        } else {
          console.warn('[MessagesComponent] No messages in response.');
        }
      },
      error: err => console.error('Error fetching messages:', err)
    });
  }

  ngOnDestroy(): void {
    this.pollingSub?.unsubscribe(); // clean up
  }
}
