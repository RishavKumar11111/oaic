import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PendingPaymentsComponent } from './pending-payments.component';

const routes: Routes = [
  {
    path: '',
    component: PendingPaymentsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PendingPaymentsRoutingModule { }
