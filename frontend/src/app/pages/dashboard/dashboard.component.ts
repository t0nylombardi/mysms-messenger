import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LogoutButtonComponent } from '../../shared/logout-button/logout-button.component';

@Component({
  standalone: true,
  selector: 'app-dashboard',
  imports: [
    CommonModule,
    LogoutButtonComponent
  ],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent {}
