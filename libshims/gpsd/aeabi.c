/*
 * SPDX-FileCopyrightText: The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 *
 * The stock gpsd (Android 9) imports __aeabi_ldiv0, which bionic no longer
 * exports. Provide the ARM EABI default: return the value it was given.
 */

long long __aeabi_ldiv0(long long r) {
    return r;
}
