import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {

  userID: string = ''
  userRole: string = ''
  constructor(
    private layoutService: LayoutService
  ) { 
    this.userID = this.layoutService.getUserID()
    this.userRole = this.layoutService.getUserRole()
  }

  ngOnInit(): void {
  }
  logout() {
    this.layoutService.logout();
  }
}
