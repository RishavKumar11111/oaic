import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ProjectWiseComponent } from './project-wise/project-wise.component';

const routes: Routes = [
  {
    path:'',
    component: ProjectWiseComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProjectWiseLedgerRoutingModule { }
