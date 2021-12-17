import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor( private router: Router,
    private layoutService: LayoutService ) { }

  ngOnInit(): void {
    let role = this.layoutService.getUserRole();
    switch(role) {
      case 'ADMIN': {
        this.router.navigate(['admin'])
        break;
      }
      case 'ACCOUNTANT': {
        this.router.navigate(['accountant'])
        break;
      }
      case 'DM': {
        this.router.navigate(['dm'])
        break;
      }
      case 'DEALER': {
        this.router.navigate(['vendor'])
        break;
      }
      case 'BANK': {
        this.router.navigate(['bank'])
        break;
      }
    }
  }

}
