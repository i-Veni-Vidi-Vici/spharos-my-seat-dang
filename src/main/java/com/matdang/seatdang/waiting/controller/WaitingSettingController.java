package com.matdang.seatdang.waiting.controller;

import com.matdang.seatdang.auth.service.AuthService;
import com.matdang.seatdang.store.repository.StoreRepository;
import com.matdang.seatdang.store.repository.query.dto.AvailableWaitingTime;
import com.matdang.seatdang.waiting.service.WaitingSettingService;
import java.time.LocalTime;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/store/setting")
public class WaitingSettingController {

    private final StoreRepository storeRepository;
    private final WaitingSettingService waitingSettingService;
    private final AuthService authService;

    @GetMapping("/available-waiting-time")
    public String availableTimeSetting(Model model) {
        Long storeId = authService.getAuthenticatedStoreId();
        model.addAttribute("availableWaitingTime", waitingSettingService.findAvailableWaitingTime(storeId));

        return "store/setting/available-waiting-time";
    }

    @PostMapping("/available-waiting-time")
    public String updateAvailableTime(@ModelAttribute AvailableWaitingTime availableWaitingTime) {
        Long storeId = authService.getAuthenticatedStoreId();
        log.debug("availableWaitingTime = {}", availableWaitingTime);

        log.debug("====== update ====");
        int result = storeRepository.updateWaitingAvailableTime(availableWaitingTime.getWaitingOpenTime(),
                availableWaitingTime.getWaitingCloseTime(), storeId);
        log.debug("==========");

        if (result == 1) {
            log.info("=== update available time ===");
        }

        return "redirect:/store/setting/available-waiting-time";
    }

    @GetMapping("/estimated-waiting-time")
    public String estimatedTimeSetting(Model model) {
        Long storeId = authService.getAuthenticatedStoreId();
        model.addAttribute("estimatedWaitingTime", waitingSettingService.findEstimatedWaitingTime(storeId).getMinute());

        return "store/setting/estimated-waiting-time";
    }

    @PostMapping("/estimated-waiting-time")
    public String updateEstimatedTime(int estimatedWaitingTime) {
        Long storeId = authService.getAuthenticatedStoreId();
        log.debug("localTime = {}", estimatedWaitingTime);

        log.debug("====== update ====");
        int result = storeRepository.updateEstimatedWaitingTime(LocalTime.of(0, estimatedWaitingTime), storeId);
        log.debug("==========");

        if (result == 1) {
            log.info("=== update estimated time ===");
        }

        return "redirect:/store/setting/estimated-waiting-time";
    }

    @GetMapping("/waiting-status")
    public String waitingStatusSetting(Model model) {
        Long storeId = authService.getAuthenticatedStoreId();
        model.addAttribute("waitingStatus", waitingSettingService.findWaitingStatus(storeId));

        return "store/setting/waiting-status";
    }

    @PostMapping("/waiting-status")
    public String changeWaitingStatus(@RequestParam int status) {
        Long storeId = authService.getAuthenticatedStoreId();
        int result = waitingSettingService.changeWaitingStatus(status, storeId);

        if (result>=1) {
            log.info("=== Change Waiting Status ===");
        }
        log.debug("result ={}", result);

        return "redirect:/store/setting/waiting-status";
    }

    @GetMapping("/waiting-people-count")
    public String peopleCountSetting(Model model) {
        Long storeId = authService.getAuthenticatedStoreId();
        model.addAttribute("waitingPeopleCount", waitingSettingService.findWaitingPeopleCount(storeId));

        return "store/setting/waiting-people-count";
    }

    @PostMapping("/waiting-people-count")
    public String updatePeopleCount(int waitingPeopleCount) {
        Long storeId = authService.getAuthenticatedStoreId();

        log.debug("====== update ====");
        int result = storeRepository.updateWaitingPeopleCount(waitingPeopleCount, storeId);
        log.debug("==========");

        if (result == 1) {
            log.info("=== update waiting people count ===");
        }

        return "redirect:/store/setting/waiting-people-count";
    }


}
