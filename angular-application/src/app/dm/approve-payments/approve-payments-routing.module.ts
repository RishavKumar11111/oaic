import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ResolverResolver } from 'src/app/auth/resolver/resolver.resolver';
import { ApprovePaymentsComponent } from './approve-payments.component';

const routes: Routes = [
  {
    path: '',
    component: ApprovePaymentsComponent,
    resolve: {
      preData: ResolverResolver
    }
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ApprovePaymentsRoutingModule { }
