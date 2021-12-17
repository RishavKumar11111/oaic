import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const RoleObject = { Role: 'BANK' };

const routes: Routes = [
  {
    path: '',
    redirectTo: 'pending-payments',
    pathMatch: 'full'
  },
  {
    path: "pending-payments",
    data: RoleObject,
    loadChildren: () => import('./pending-payments/pending-payments.module').then(module => module.PendingPaymentsModule)
  },
  {
    path: 'confirmed-payments-list',
    data: RoleObject,
    loadChildren: () => import('./confirmed-payments-list/confirmed-payments-list.module').then(module => module.ConfirmedPaymentsListModule)
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class BankRoutingModule { }
