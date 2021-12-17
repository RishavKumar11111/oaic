import { PartlyMoneyReceiveComponent } from './partly-money-receive/partly-money-receive.component';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    component: PartlyMoneyReceiveComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PartlyMoneyReceiveRoutingModule { }
