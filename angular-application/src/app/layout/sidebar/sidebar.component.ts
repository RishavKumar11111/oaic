import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent implements OnInit {

  userRole: string = '';
  constructor(private layoutService: LayoutService) { 
    this.userRole = this.layoutService.getUserRole();
  }

  ngOnInit(): void {
  }

}
