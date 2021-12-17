import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { PartlyMoneyReceiveComponent } from './partly-money-receive.component';

describe('PartlyMoneyReceiveComponent', () => {
  let component: PartlyMoneyReceiveComponent;
  let fixture: ComponentFixture<PartlyMoneyReceiveComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PartlyMoneyReceiveComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PartlyMoneyReceiveComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
