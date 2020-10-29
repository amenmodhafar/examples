//
//  Schema.swift
//  PoseNet
//
//  Created by Apple  on 2020-10-24.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation


public class Schema{
    
    
    public func Schema()
    {
        workoutNames = []
    }
    
    private let fullbodyExercise: [String] = ["LEG EXTENSION CRUNCHES", "LEG CLIMBERS", "FROGGY CRUNCHES", "JUMPING JACKS", "BURPEES", "LEG EXTENSION CRUNCHES", "CLEANS","CLEANS", "CLEANS", "CLEANS", "CLEANS", "DEADLIFTS", "DEADLIFTS", "DEADLIFTS", "DEADLIFTS", "STIFF LEG DEADLIFT", "STIFF LEG DEADLIFT", "STIFF LEG DEADLIFT" , "PUSH-UPS", "WIDE ARM PUSH-UPS", "MILITARY PUSH-UPS", "DIAMOND PUSH-UPS"]
    private let lowerExercise: [String] = ["FORWARD LUNGES", "SQUATS", "SUMO SQUATS", "REVERSE LUNGES","LATERAL LUNGES RIGHT", "LATERAL LUNGES LEFT", "FRONT SQUATS", "DIAGONAL LUNGES RIGHT", "DIAGONAL LUNGES LEFT", "LUNGE AND TWIST", "KURTSY LUNGES", "STANDING LUNGES"]
    private let backExcercise: [String] = ["SINGLE-LEGGED DEADLIFTS", "CHIN-ups", "KETTLEBELL SWINGS", "WIDE GRIP PULL-ups", "ROMANIAN DEADLIFTS", "CLEAN & JERKS", "STIFF-LEGGED DEADLIFTS", "CLEANS", "BACK EXTENSIONS", "BENTOVER ROW", "HIGH-PULLS"]
    private let coreExcercise: [String] = ["SIT-ups", "STANDING SIDE-DIPS", "LEG CLIMBERS", "FROG CRUNCHES", "LEG EXTENSION CRUNCHES", "GET-ups", "RUSSIAN TWISTS", "SIDE-BRIDGES RIGHT", "SIDE-BRIDGES LEFT", "V-ups", "PLANK"]
    private let plyometicExcercise: [String] = ["JUMPING JACKS", "BOX JUMPS", "BURPEES", "JUMP ROPES", "JUMP SQUATS", "OVERTIRE JUMPS", "LATERAL SKATER JUMPS", "SKATER JUMP LUNGES"]
    private let armExcercise: [String] = ["TRICEPS DIPS", "ARM CURL CRUNCHES LEFT","ARM CURL CRUNCHES RIGHT","MILITARY PUSH-UPS","SQUAT SHOULDER PRESSES"]
    private let chestExcercise: [String] = ["PUSH-ups", "INCLINE PUSH-ups","WIDE ARM PUSH-ups","KNEE PUSH-ups","DIAMOND PUSH-ups", "PUSH-ups & ROTATE", "DECLINE PUSH-ups", "CHEST DIPS"]
    private let chestlowercoreExercise: [String] = ["PUSH-ups","FORWARD LUNGES","SIDE-BRIDGES RIGHT","WIDE ARM PUSH-ups", "SQUATS", "SIDE-BRIDGES LEFT","BURPEES", "ONE-LEGGED DEADLIFTS", "RIGHT LEG CLIMBERS","DIAMOND PUSH-ups", "LEFT LEG CLIMBERS", "SUMO SQUATS", "FROG CRUNCHES","PUSH-ups & ROTATE", "LATERAL LUNGES RIGHT", "LATERAL LUNGES LEFT", "V-ups", "KNEE PUSH-ups"]
    private let lowerarmsExercise: [String] = ["FIGURE 8","FOREHAND STROKES", "BACKHAND STROKES","SERVICE"]
    private let chestplyoExercise: [String] = ["JUMPING JACKS","PUSH-ups","SIDE-BRIDGES RIGHT","JUMP SQUATS","WIDE ARM PUSH-ups", "SIDE-BRIDGES LEFT","BURPEES", "ONE-LEGGED DEADLIFTS", "OVERTIRE JUMPS","RIGHT LEG CLIMBERS","DIAMOND PUSH-ups", "LEFT LEG CLIMBERS", "FROG CRUNCHES", "LATERAL SKATER JUMPS", "PUSH-ups & ROTATE", "V-ups", "JUMPING JACKS"]
    private let superset1: [String] = ["INCLINE PUSH-ups", "JUMP SQUATS", "DUMBBELL SNATCH", "LEG EXTENSION CRUNCHES", "CHIN-ups","LATERAL SKATER JUMPS"]
    private let pushpullExercise: [String] = ["PUSH-ups", "CHIN-ups", "WIDE ARM PUSH-ups", "WIDE GRIP PULL-ups", "MILITARY PUSH-ups", "ONE-LEGGED DEADLIFTS", "INCLINE PUSH-ups","KETTLEBELL SWINGS", "DIAMOND PUSH-ups"]
    private let athleticConditioningExercise: [String] = ["JUMPING JACKS", "SUMO SQUATS", "SINGLE-LEGGED DEADLIFTS", "PUSH-ups", "FORWARD LUNGES", "TRICEPS DIPS", "CHIN-ups", "SQUAT SHOULDER PRESSES", "LEG EXTENSION CRUNCHES" , "REVERSE LUNGES"]
    private let legandarmsExercise: [String]  = ["FORWARD LUNGES", "TRICEPS DIPS", "SQUATS", "MILITARY PUSH-ups", "SUMO SQUATS", "SQUAT SHOULDER PRESSES","REVERSE LUNGES", "WIDE ARM PUSH-ups","LATERAL LUNGES RIGHT", "LATERAL LUNGES LEFT", "CHIN-ups", "FRONT SQUATS", "WIDE ARM PULL-ups"]
    private let boxingExercise: [String] = ["SKIPPING ROPE","JAB, CROSS", "JAB, CROSS, LEFT HOOK", "JAB, CROSS, CROSS", "JAB, JAB, CROSS", "RIGHT HOOK, LEFT HOOK", "JAB, RIGHT UPPER CUT", "JAB, CROSS, LEFT UPPER CUT, RIGHT HOOK", "LEG EXTENSION CRUNCHES", "STANDING SIDE DIPS","SIDE-BRIDGES RIGHT", "SIDE-BRIDGES LEFT", "V-ups"]
    private let dancingExercise: [String] = ["ONE TWO STEP", "FREESTYLE DANCE", "BELLY DANCING"]
    private let golfExercise: [String] = ["WEDGE", "6 IRON", "7 IRON", "DRIVER"]
    
    public var workoutNames: [String] = []
    
    public func getCurrentExerName (_ setNum: Double) -> String
    {
      if(setNum >= 1)
        {
            return workoutNames[(Int(setNum) - 1) % workoutNames.count]
        }
        else{
            return workoutNames[(workoutNames.count - Int(setNum) - 1) % workoutNames.count]
        }
    }
    
    public func createSuperSet(_ superSetName: String)
    {
        if (superSetName.elementsEqual("ARMS AND SHOULDERS"))
        {
            workoutNames = armExcercise
        }
        else if (superSetName.elementsEqual("LEGS FOR DAYS"))
        {
            workoutNames = lowerExercise
        }
        else if (superSetName.elementsEqual("BACK STRENGTH"))
        {
            workoutNames = backExcercise
        }
        else if (superSetName.elementsEqual("BEST CHEST"))
        {
            workoutNames = chestExcercise
        }
        else if (superSetName.elementsEqual("HIGH INTENSITY INTERVALS"))
        {
            workoutNames = plyometicExcercise
        }
        else if (superSetName.elementsEqual("ABS NO KABABS"))
        {
            workoutNames = coreExcercise
        }
        else if (superSetName.elementsEqual("FULL BODY WEIGHT"))
        {
            workoutNames = chestlowercoreExercise
        }
        else if (superSetName.elementsEqual("FULL BODY AGILITY"))
        {
            workoutNames = chestplyoExercise
        }
        else if (superSetName.elementsEqual("TENNIS SPECIAL"))
        {
            workoutNames = lowerarmsExercise
        }
        else if (superSetName.elementsEqual("ARMY SUPERSET"))
        {
            workoutNames = superset1
        }
        else if (superSetName.elementsEqual("GOLF SPECIAL"))
        {
            workoutNames = golfExercise
        }
        else if (superSetName.elementsEqual("DANCY DANCE"))
        {
            workoutNames = dancingExercise
        }
        else if (superSetName.elementsEqual("PUSH PULL"))
        {
            workoutNames = pushpullExercise
        }
        else if (superSetName.elementsEqual("ARMS AND LEGS"))
        {
            workoutNames = legandarmsExercise
        }
        else if (superSetName.elementsEqual("BOXING SPECIAL"))
        {
            workoutNames = boxingExercise
        }
        else if (superSetName.elementsEqual("ATHLETIC CONDITIONING"))
        {
            workoutNames = athleticConditioningExercise
        }
        else if (superSetName.elementsEqual("FULL BODY STRENGTH"))
        {
            workoutNames = fullbodyExercise
        }
    }
    
}
