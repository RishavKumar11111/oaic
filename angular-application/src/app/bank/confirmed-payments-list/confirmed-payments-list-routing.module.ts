import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ConfirmedPaymentsListComponent } from './confirmed-payments-list.component';

const routes: Routes = [
  {
    path: '',
    component: ConfirmedPaymentsListComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ConfirmedPaymentsListRoutingModule { }
