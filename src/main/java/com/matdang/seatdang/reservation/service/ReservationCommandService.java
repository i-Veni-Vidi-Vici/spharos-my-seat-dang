package com.matdang.seatdang.reservation.service;

import com.matdang.seatdang.common.exception.ReservationException;
import com.matdang.seatdang.reservation.dto.ReservationSaveRequestDto;
import com.matdang.seatdang.reservation.entity.Reservation;
import com.matdang.seatdang.reservation.repository.ReservationRepository;
import com.matdang.seatdang.reservation.vo.ReservationStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@Transactional
@Service
public class ReservationCommandService {
    private final ReservationRepository reservationRepository;

    public void createCustomMenuReservation(ReservationSaveRequestDto saveRequestDto) {
        log.debug("create empty reservation dto: {}", saveRequestDto);
        saveRequestDto.setReservationStatus(ReservationStatus.DETAILING);
        boolean reservationExists =reservationRepository.findByCustomer_CustomerIdAndReservedAt(saveRequestDto.getCustomer().getCustomerId(), LocalDateTime.of(saveRequestDto.getDate(),saveRequestDto.getTime())).isPresent();
        if (reservationExists) {
            throw new ReservationException("같은 시간에 중복된 예약이 있습니다");
        }
        reservationRepository.save(saveRequestDto.toEntity());
    }

    public void updateStatusCustomReservation(Long reservationId, ReservationStatus reservationStatus) {
        log.debug("update reservation status to PAYMENT_COMPLETED service: {}", reservationId);
        Optional<Reservation> optReservation = reservationRepository.findById(reservationId);
        Reservation reservation = optReservation.orElseThrow( ()-> new ReservationException("예약을 찾을수 없습니다"));
        reservation.updateStatus(reservationStatus);
    }

    public void cancelReservation(Long reservationId) {

    }
}
