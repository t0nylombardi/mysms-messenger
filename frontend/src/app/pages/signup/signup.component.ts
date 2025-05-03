import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  standalone: true,
  selector: 'app-signup',
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss'],
})
export class SignupComponent {
  credentials = {
    email: '',
    password: '',
    password_confirmation: '',
  };

  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  onSignup(): void {
    this.authService.signup({
      user: {
        email: this.credentials.email,
        password: this.credentials.password,
        password_confirmation: this.credentials.password_confirmation,
      }
    }).subscribe({
      next: () => {
        this.router.navigate(['/messages']);
        console.log('Signed up!');
      },
      error: err => console.error('Signup failed:', err)
    });
  }
}
