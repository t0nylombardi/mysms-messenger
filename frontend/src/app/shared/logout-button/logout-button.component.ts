import { Component } from '@angular/core';

@Component({
  standalone: true,
  selector: 'app-logout-button',
  templateUrl: './logout-button.component.html',
  styleUrls: ['./logout-button.component.scss']
})
export class LogoutButtonComponent {
  logout() {
    // logic to logout
  }
}
