import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../services/auth.service';

@Component({
  standalone: true,
  selector: 'app-login',
  imports: [CommonModule, FormsModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent {
  credentials = {
    username: '',
    password: '',
  };

  constructor(private authService: AuthService) {}

  onLogin(): void {
    this.authService.login(this.credentials).subscribe({
      next: () => {
        console.log('Logged in successfully');
      },
      error: (err) => {
        console.error('Login failed', err);
      },
    });
  }
}
