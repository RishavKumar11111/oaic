import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { AgainstPermitComponent } from './against-permit.component';

describe('AgainstPermitComponent', () => {
  let component: AgainstPermitComponent;
  let fixture: ComponentFixture<AgainstPermitComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AgainstPermitComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AgainstPermitComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
